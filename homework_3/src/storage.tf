# Создание бакета Object Storage с шифрованием
resource "yandex_storage_bucket" "student_bucket" {
  bucket     = var.bucket_name
  acl        = "public-read"
  folder_id  = var.yc_folder_id

  # Включение шифрования с помощью KMS ключа
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  depends_on = [yandex_kms_symmetric_key.bucket_key]
}

# Загрузка картинки в бакет
resource "yandex_storage_object" "image" {
  bucket = yandex_storage_bucket.student_bucket.bucket
  key    = "yandex.png"
  source = var.image_file_path
  acl    = "public-read"

  depends_on = [yandex_storage_bucket.student_bucket]
}

# Output для URL картинки
#output "image_url" {
#  value = "https://${yandex_storage_bucket.student_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.image.key}"
# }
