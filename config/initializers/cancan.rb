module CanCan
  class ControllerResource
    alias_method :original_resource_params_by_namespaced, :resource_params_by_namespaced_name

    def resource_params_by_namespaced_name
      if (@controller && @params && @params[:action] == "create")
        name          = namespaced_name.try(:name).presence || namespaced_name
        strong_params =  @controller.method("#{name.downcase}_params".to_sym)
        params        = strong_params.call if defined? strong_params
      end

      params ||=  original_resource_params_by_namespaced
    end
  end
end
