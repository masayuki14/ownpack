class StepsController < ApplicationController

  #　ステップ追加
  def add
    @recipe = Recipe.find(params[:recipe_id])
    return @step = Step.new if @recipe.user_id != session[:user].id
    Step.slide_up(params[:step_id])
    step = Step.new_next(params[:step_id])
    step.save
  end

  # ステップ削除
  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    return @step = Step.new if @recipe.user_id != session[:user].id
    Step.slide_down(params[:id])
    step = Step.where(:id => params[:id], :recipe_id => params[:recipe_id]).first
    step.destroy
  end

  def move_lower
    @recipe = Recipe.find(params[:recipe_id])
    return @step = Step.new if @recipe.user_id != session[:user].id
    Step.move(:lower, :id => params[:step_id])
  end

  def move_higher
    @recipe = Recipe.find(params[:recipe_id])
    return @step = Step.new if @recipe.user_id != session[:user].id
    Step.move(:higher, :id => params[:step_id])
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
