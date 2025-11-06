# Создание бакета
resource "yandex_storage_bucket" "student_bucket" {
  bucket = "sergeikoost-${formatdate("YYYY-MM-DD", timestamp())}"

  anonymous_access_flags {
    read = true
    list = false
  }
}

# Загрузка картинки
resource "yandex_storage_object" "web_image" {
  bucket = yandex_storage_bucket.student_bucket.bucket
  key    = "web-image.jpg"
  source = "web-image.jpg"  # Положите файл картинки в папку с Terraform

  # Настройки доступа
  acl = "public-read"
}
