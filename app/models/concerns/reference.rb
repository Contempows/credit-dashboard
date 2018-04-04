module Reference
  extend ActiveSupport::Concern

  included do
    validates :ref, uniqueness: true
  end

  def generate_ref_code(klass)
    loop do
      token = SecureRandom.base64.tr('1234567890+/=', 'abcdefghijxyz')[0...6].upcase
      break token unless klass.exists?(ref: token)
    end
  end
end
