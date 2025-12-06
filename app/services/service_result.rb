class ServiceResult
  attr_reader :success, :data, :errors, :status

  def initialize(success:, data: nil, errors: nil, status: nil)
    @success = success
    @data = data
    @errors = errors
    @status = status
  end

  def self.success(data)
    new(success: true, data: data)
  end

  def self.failure(errors, status = :unprocessable_entity)
    new(success: false, errors: errors, status: status)
  end

  def success?
    @success
  end
end
