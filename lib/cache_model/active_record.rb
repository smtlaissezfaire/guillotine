ActiveRecord::Base.instance_eval do
  def cache_model
    @__cached_model ||= CacheModel::CachedModel.new(self)
  end
end
