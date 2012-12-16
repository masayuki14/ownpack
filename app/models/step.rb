class Step < ActiveRecord::Base
  attr_accessible :recipe_id, :filepath, :memo, :step_order
  attr_accessible :uploaded_picture
  belongs_to :recipe

  # Class Methods
  class << self

    # ステップ順序の最大値
    def max_step_order(recipe_id)
      where(:recipe_id => recipe_id).order('step_order DESC').first.step_order.to_i
    end

    # 指定IDのステップより1大きい設定
    def new_next(id)
      current = find(id)
      step = new(:recipe_id => current.recipe_id, :step_order => current.step_order + 1)
    end

    # 指定IDのステップより大きいやつらのステップを1増やす
    def slide_up(id)
      current = find(id)
      steps = where(:recipe_id => current.recipe_id).where('step_order > ?', current.step_order)
      steps.each do |step|
        step.step_order += 1
        step.save
      end
    end

    # 指定IDのステップより大きいやつらのステップを1減らす
    def slide_down(id)
      current = find(id)
      steps = where(:recipe_id => current.recipe_id).where('step_order > ?', current.step_order)
      steps.each do |step|
        step.step_order -= 1
        step.save
      end
    end

    def move(*args)
      scope   = args.slice!(0)
      options = args.slice!(0) || {}

      current = find(options[:id])
      case scope
      when :higher
        higher  = where(:recipe_id => current.recipe_id).where(:step_order => current.step_order + 1).first
        return if higher.blank?
        replace(current, higher)
      when :lower
        lower = where(:recipe_id => current.recipe_id).where(:step_order => current.step_order - 1).first
        return if lower.blank?
        replace(lower, current)
      end
    end

    private

    def replace(former, latter)
      former.step_order += 1
      former.save
      latter.step_order -= 1
      latter.save
    end
  end

  def uploaded_picture=(picture_field)
    # 許可するファイルはjpeg,gif,png
    @extension = picture_field.content_type.split('/', 2)[1]
    @uploaded_picture = picture_field
  end

  before_update :set_filepath
  after_save    :write_uploaded_picture

private

  # ID+timestampでMD5ハッシュをとり、前2文字をディレクトリ名、それ以降をファイル名とする
  def set_filepath
    return if @uploaded_picture.blank?
    return if !self.filepath.blank?
    filename = Digest::MD5.hexdigest("#{self.id}#{Time.new.to_f}").insert(2, '/') + '.' + @extension
    self.filepath = File.join(Ownpack::Application.config.upload_dir, filename)
  end

  #== 画像ファイルを保存する
  def write_uploaded_picture
    return if @uploaded_picture.blank?
    pathname = Ownpack::Application.config.upload_image_root + File.dirname(self.filepath)
    pathname.mkdir unless pathname.exist?
    File.open(File.join(Ownpack::Application.config.upload_image_root, self.filepath), 'wb') do |fp|
      fp.write(File.read(@uploaded_picture.path))
    end
  end
end
