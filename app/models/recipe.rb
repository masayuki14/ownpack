require 'digest/md5'

class Recipe < ActiveRecord::Base
  MODE_DRAFT = 'draft'
  attr_accessible :catch_copy, :history, :knack, :time_required, :title, :user_id, :filepath, :uploaded_picture
  belongs_to :user
  has_many :steps

  scope :draft, where(:active => false)
  scope :active, where(:active => true)

  validates :title,
    :presence => true,
    :length => {:maximum => 20}
  validates :catch_copy, :length => {:maximum => 20}
  validates :history, :length => {:maximum => 100}
  validates :knack, :length => {:maximum => 100}
  validates :time_required,
    :numericality => {:only_integer => true, :less_than_or_equal_to => 30}

  validate :picture_presence?


  #== 写真アップロードが行われているか
  def picture_presence?
    errors.add(:uploaded_picture, "can't be blank" ) if @uploaded_picture.blank?
  end

  #== ファイル保存の事前処理
  # TODO: サイズチェックとかリサイズとかしないと
  def uploaded_picture=(picture_field)
    # 許可するファイルはjpeg,gif,png
    @extension = picture_field.content_type.split('/', 2)[1]
    @uploaded_picture = picture_field
  end

  before_update :set_filepath
  after_create  :set_filepath, :save
  after_save    :write_uploaded_picture

private

  def set_filepath
    self.filepath = File.join(dir_path, filename) if self.filepath.blank?
  end

  #== 画像ファイルを保存する
  def write_uploaded_picture
    return if @uploaded_picture.blank?
    return if @uploaded_picture.size == 0

    make_dir
    File.open(File.join(Tutorial::Application.config.upload_image_root, self.filepath), 'wb') do |fp|
      fp.write(File.read(@uploaded_picture.path))
    end
  end

  def dir_path
    File.join(Tutorial::Application.config.upload_dir, self.user_id.to_s)
  end

  def make_dir
    pathname = Tutorial::Application.config.upload_image_root + dir_path
    pathname.mkdir unless pathname.exist?
  end

  def filename
    Digest::MD5.hexdigest("#{self.id}#{Time.new.to_f}") + '.' + @extension
  end

end
