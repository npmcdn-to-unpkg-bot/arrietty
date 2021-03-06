class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :contact_form, :contact]
  before_action :authenticate_user!
  before_action :check_edit_permission!, only: [:edit, :update]

  def index
    @products = Product.not_owned_by(current_user)
    if params[:q]
      @products = @products.contains?(params[:q])
    end
  end
  
  def my_products
    @products = current_user.products
  end
  
  def search
    @products = Product.all
  end

  
  
  def contact
    if @product.status.to_sym != :available
      flash[:alert] = 'Cannot contact owner'
      redirect_to root_path
    end 
    
    ProductMailer.contact_email(@product, params[:body]).deliver_now

    flash[:notice] = "Request Sent!"

    #TODO: This should redirect to the product
    redirect_to root_path
  end

  def new
    @product = Product.new
    render :layout => false
  end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      flash[:success] = 'product was successfully created.'
      render :show, :layout => false 
    else
      render :new, :layout => false
    end
  end

  def update
    if @product.update(product_params)
      flash[:success] = 'product was successfully updated.'
      render :show, :layout => false 
    else
      render :edit, :layout => false
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: 'product was successfully destroyed.'
  end
  
  def show 
    render :layout => false
  end
  
  def edit 
    render :layout => false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :category_id, :price, :image, :description, :status)
    end
    
    def check_edit_permission!
      if not current_user.owns? @product
        flash[:alert] = 'Cannot edit product'
        redirect_to root_path
      end
    end
end
