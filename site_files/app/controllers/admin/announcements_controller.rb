class Admin::AnnouncementsController < Admin::BaseController

  before_filter :change_background_form_ui, :only => [:new, :edit]
  after_filter :save_background, :only => [:create, :update]

  active_scaffold :announcement do |config|
    Scaffoldapp::active_scaffold config, "admin.announcements",
      :list         => [ :title, :headline, :starts_at, :ends_at ],
      :show         => [ :title, :starts_at, :ends_at, :background, :headline, :message ],
      :create       => [ :title, :starts_at, :ends_at, :background, :headline, :message ],
      :edit         => [  ]
  end

  private

    def change_background_form_ui
      active_scaffold_config.create.columns.each do |column|
        column.form_ui = :file if column.name == :background
      end
      active_scaffold_config.create.multipart = true
      active_scaffold_config.update.multipart = true
    end

    def save_background
      if upload = params[:record][:background]
        directory = "public/images/announcements"
        Dir.mkdir directory unless File.exists? directory
        path = File.join("public/images/announcements", "#{@record.id}.png")
        File.open(path, "wb") { |file| file.write upload.read }
        @record.update_attribute :background, path
      end
    end

end
