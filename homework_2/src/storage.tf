# Создание бакета Object Storage
resource "yandex_storage_bucket" "student_bucket" {
  bucket     = var.bucket_name
  acl        = "public-read"
  folder_id  = var.yc_folder_id

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

# Загрузка картинки в бакет
resource "yandex_storage_object" "image" {
  bucket = yandex_storage_bucket.student_bucket.bucket
  key    = "yandex.png"  # Изменили на ваше имя файла
  source = var.image_file_path
  acl    = "public-read"

  depends_on = [yandex_storage_bucket.student_bucket]
}

# Output для URL картинки
#output "image_url" {
#  value = "https://${yandex_storage_bucket.student_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.image.key}"
# }
