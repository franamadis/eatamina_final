ActiveAdmin.register Product do
    # actions :index, :show, :create, :edit, :update, :destroy
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
permit_params :name, :sku, :photo, :status, :response, :nutritional_info, :prod_add, :brand, :nutrition_grade
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

end
