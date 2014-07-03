require 'openssl'
require "base64"

# stolen from http://stuff-things.net/2008/02/05/encrypting-lots-of-sensitive-data-with-ruby-on-rails/
module Crypto
  CRYPT_256_BIT_AES_CBC = 'aes-256-cbc'
  TEST_PASSWORD = 'xxxxxx'

  def encrypt(plain_data)
    cipher = OpenSSL::Cipher::Cipher.new(CRYPT_256_BIT_AES_CBC)
    cipher.encrypt
    cipher.key  = random_key  = cipher.random_key
    cipher.iv   = random_iv   = cipher.random_iv

    encrypted_data = cipher.update(plain_data)
    encrypted_data << cipher.final

    public_key_file = Rails.root.join("config/keys/public_#{Rails.env}.pem")
    public_key      = OpenSSL::PKey::RSA.new(File.read(public_key_file))

    encrypted_key = public_key.public_encrypt(random_key)
    encrypted_iv  = public_key.public_encrypt(random_iv)

    {
      encrypted_data: encode(encrypted_data),
      encrypted_key: encode(encrypted_key),
      encrypted_iv: encode(encrypted_iv)
    }
  end

  def decrypt(data, password = runtime_password)
    private_key_file  = Rails.root.join("config/keys/private_#{Rails.env}.pem")
    private_key       = OpenSSL::PKey::RSA.new(File.read(private_key_file), password)

    cipher = OpenSSL::Cipher::Cipher.new(CRYPT_256_BIT_AES_CBC)
    cipher.decrypt
    cipher.key  = private_key.private_decrypt(decode(data[:encrypted_key]))
    cipher.iv   = private_key.private_decrypt(decode(data[:encrypted_iv]))

    decrypted_data = cipher.update(decode(data[:encrypted_data]))
    decrypted_data << cipher.final
  end

  private

  def encode(text)
    Base64.encode64(text)
  end

  def decode(text)
    Base64.decode64(text)
  end

  def runtime_password
    TEST_PASSWORD || ENV['TEST_PASSWORD']
  end
end
