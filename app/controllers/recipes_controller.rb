class RecipesController < ApplicationController
  before_action :find_user
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_response
  
  def index
    render json: @user.recipes, include: :user, status: :created
  end

  def create
    recipe = Recipe.new(recipe_params)
    @user.recipes << recipe
    recipe.save!
    render json: recipe, status: :created
  end

  private

  def find_user
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      render json: { errors: ["Please Login"] }, status: :unauthorized
    end
  end

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete)
  end

  def invalid_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end
end
