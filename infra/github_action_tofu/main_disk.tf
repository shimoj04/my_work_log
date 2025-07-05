############################################################
# 0. backend（state 保存先）
############################################################
terraform {
  backend "s3" {
    bucket = var.object_storage_name
    endpoints {
      s3 = var.sakuracloud_api_endpoint
    }
    # ── 認証情報
    access_key = var.aws_access_key_id
    secret_key = var.aws_secret_access_key

    skip_credentials_validation = true
    skip_region_validation      = true
    force_path_style            = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
  required_providers {
    sakuracloud = {
      source  = "sacloud/sakuracloud"
      version = "2.27.0"
    }
  }
}

provider "sakuracloud" {
  zone = "is1a"
}

############################################################
# 2. diskのリソース作成
  ## test
############################################################
data "sakuracloud_archive" "rockylinux" {
  os_type = "rockylinux"
}

resource "sakuracloud_disk" "disk_from_tofu_test" {
  name              = "disk_from_tofu"
  plan              = "ssd"
  connector         = "virtio"
  size              = 20
  source_archive_id = data.sakuracloud_archive.rockylinux.id
}


############################################################
# 3. 出力
############################################################
output "disk_id" {
  value = sakuracloud_disk.disk_from_tofu_test.id
  description = "作成したディスクの ID（UUID）"
}
