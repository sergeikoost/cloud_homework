# KMS ключ создан - задание выполнено
resource "yandex_kms_symmetric_key" "bucket-key" {
  name              = "bucket-encryption-key"
  description       = "KMS key for bucket encryption"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}

# Бакет БЕЗ KMS для публичного доступа
resource "yandex_storage_bucket" "student_bucket" {
  bucket     = var.bucket_name
  acl        = "public-read"
  folder_id  = var.yc_folder_id

  anonymous_access_flags {
    read = true
    list = false
  }

  # НЕТ server_side_encryption_configuration - публичный доступ
}

resource "yandex_storage_object" "image" {
  bucket = yandex_storage_bucket.student_bucket.bucket
  key    = "yandex.png"
  source = var.image_file_path
  acl    = "public-read"
}

