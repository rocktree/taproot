if Rails.env.development?

  Dbsync.file_config = {
    :remote => SapwoodSetting.remote.db_backup_file,
    :local  => SapwoodDatabase.new.backup_file_copy
  }

end
