resource "yandex_iam_service_account" "storage-sa" {
  name        = "storage-sa"
  description = "Service account for storage and compute management"
}


resource "yandex_resourcemanager_folder_iam_member" "storage-editor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.storage-sa.id}"
}


resource "yandex_resourcemanager_folder_iam_member" "compute-admin" {
  folder_id = var.yc_folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.storage-sa.id}"
}


resource "yandex_resourcemanager_folder_iam_member" "vpc-user" {
  folder_id = var.yc_folder_id
  role      = "vpc.user"
  member    = "serviceAccount:${yandex_iam_service_account.storage-sa.id}"
}


resource "yandex_resourcemanager_folder_iam_member" "load-balancer-admin" {
  folder_id = var.yc_folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.storage-sa.id}"
}