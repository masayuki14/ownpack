class Step < ActiveRecord::Base
  attr_accessible :recipe_id, :filepath, :memo, :step_order, :uploaded_picture
  belongs_to :recipe

  # Class Methods
  class << self

    # ステップ順序の最大値
    def max_step_order(recipe_id)
      where(:recipe_id => recipe_id).order('step_order DESC').first.step_order.to_i
    end

    def create_next(step_id)
      current = find(step_id)
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

  #== 画像ファイルを保存する
  def write_uploaded_picture
    return if @uploaded_picture.blank?
    return if @uploaded_picture.size == 0

    make_dir
    File.open(File.join(Tutorial::Application.config.upload_image_root, self.filepath), 'wb') do |fp|
      fp.write(File.read(@uploaded_picture.path))
    end
  end

  def make_dir
    pathname = Tutorial::Application.config.upload_image_root + Tutorial::Application.config.upload_dir + @filename.slice(0, 2)
    pathname.mkdir unless pathname.exist?
  end

  # ID+timestampでMD5ハッシュをとり、前2文字をディレクトリ名、それ以降をファイル名とする
  def set_filepath
    return if @uploaded_picture.blank?
    @filename = Digest::MD5.hexdigest("#{self.id}#{Time.new.to_f}").insert(2, '/') + '.' + @extension
    self.filepath = File.join(Tutorial::Application.config.upload_dir, @filename) if self.filepath.blank?
  end
end
