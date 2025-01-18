class Api::V1::Items::SearchController < ApplicationController
  before_action :validate_params

  def show
    return handle_item_show_search(params) if params[:name].present?

    min = params[:min_price] if params[:min_price]
    max = params[:max_price] if params[:max_price]

    item = Item.find_one_item_by_price(
      **{ min_price: min }.compact,
      **{ max_price: max }.compact
    )

    if item.present?
      render json: ItemSerializer.new(item)
    else
      render json: { data: { } }
    end
  end

  def index
    return handle_item_index_search(params) if params[:name].present?
      
    min = params[:min_price].to_f if params[:min_price]
    max = params[:max_price].to_f if params[:max_price]

    items = Item.find_items_by_price(
      **{ min_price: min }.compact,
      **{ max_price: max }.compact
      )

    render json: ItemSerializer.new(items)
  end

  private

  def handle_item_show_search(params)
    search_response = Item.find_one_item_by_name(params[:name])
    render json: { data: { } } and return if search_response.nil?
    render json: ItemSerializer.new(search_response), status: :ok
  end
  
  def handle_item_index_search(params)
    search_response = Item.find_all_by_name(params[:name])
    render json: ItemSerializer.new(search_response), status: :ok
  end
  

  def validate_params
    return render_error if price_params_negative?(params)
    return render_error if no_search_params?(params)
    return render_error if name_and_price_params_included?(params)
    return render_error if invalid_min_or_max?(params)
  end

  def name_and_price_params_included?(params)
    params.include?(:name) && (params.include?(:min_price) || params.include?(:max_price))
  end

  def price_params_negative?(params)
    return true if params[:min_price].present? && params[:min_price].to_f < 0

    params[:max_price].present? && params[:max_price].to_f < 0
  end

  def invalid_min_or_max?(params)
    min = params[:min_price] ? params[:min_price].to_f : 0
    max = params[:max_price] ? params[:max_price].to_f : Float::MAX

    min > max
  end

  def no_search_params?(params)
    !params[:min_price].present? && !params[:max_price].present? && !params[:name].present?
  end
end