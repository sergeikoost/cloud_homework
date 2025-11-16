# Создание ключа KMS
resource "yandex_kms_symmetric_key" "bucket_key" {
  name              = var.kms_key_name
  description       = "KMS key for encrypting Object Storage bucket"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год

  # Права доступа для сервисного аккаунта
  depends_on = [yandex_iam_service_account.storage_admin]
}

# Назначение прав сервисному аккаунту на использование ключа
resource "yandex_kms_symmetric_key_iam_binding" "viewer" {
  symmetric_key_id = yandex_kms_symmetric_key.bucket_key.id
  role             = "viewer"

  members = [
    "serviceAccount:${yandex_iam_service_account.storage_admin.id}",
  ]
}
