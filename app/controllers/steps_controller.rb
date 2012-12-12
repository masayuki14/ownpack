class StepsController < ApplicationController
  def create
    @step = Step.new(:recipe_id => params[:recipe_id])
    @step.save
    @step.update_attributes(:step_order => Step.max_step_order(params[:recipe_id]) + 1)
    @recipe = Recipe.find(params[:recipe_id])
  end

  def add
    @step = Step.create_next(params[:step_id])
    #@step = Step.new(:recipe_id => params[:recipe_id])
    #@step.save
    #@step.update_attributes(:step_order => Step.max_step_order(params[:recipe_id]) + 1)
    @recipe = Recipe.find(params[:recipe_id])
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    return @step = Step.new if @recipe.user_id != session[:user].id
    @step = Step.where(:id => params[:id], :recipe_id => params[:recipe_id]).first
    @step.destroy
  end

  def move_lower
  end

  def move_higher
  end

  def upload_photo
    @recipe = Recipe.find(params[:recipe_id])
    return if @recipe.user_id != session[:user].id
    @step = Step.find(params[:step_id])
    @step.update_attributes(params[:step].select {|k,v| ['uploaded_picture'].member?(k)})
    redirect_to @recipe, notice: 'File was successfully uploaded.'
  end

  #==  updateできるのはmemoとuploaded_fileだけ
  def update
    @recipe = Recipe.find(params[:recipe_id])
    return if @recipe.user_id != session[:user].id
    @step = Step.find(params[:id])
    if @step.update_attributes(params[:step].select {|k,v| ['memo'].member?(k)})
      redirect_to @recipe, notice: 'Step was successfully updated.'
    else
    end
  end
end
