# Создание бакета в Object Storage
resource "yandex_storage_bucket" "student_bucket" {
  bucket     = "kusk111serj-${formatdate("YYYY-MM-DD", timestamp())}"
  folder_id  = var.yc_folder_id

  anonymous_access_flags {
    read = true
    list = false
  }

  acl = "public-read"
}

# Загрузка картинки в бакет
resource "yandex_storage_object" "web_image" {
  bucket = yandex_storage_bucket.student_bucket.bucket
  key    = "yandex.png"
  source = "yandex.png"
  acl    = "public-read"
}