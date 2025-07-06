############################################################
# 0. backend（state 保存先）
############################################################
terraform {
  backend "s3" {
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
############################################################
data "sakuracloud_archive" "rockylinux" {
  os_type = "rockylinux"
}

resource "sakuracloud_disk" "disk_from_tofu" {
  name              = "disk_from_tofu"
  plan              = "ssd"
  connector         = "virtio"
  size              = 20
  source_archive_id = data.sakuracloud_archive.rockylinux.id
}


resource "sakuracloud_switch" "my_switch" {
  name        = "my-open-tofu-switch"
  description = "Created via OpenTofu"
  tags        = ["202507", "tofu"]
}

############################################################
# 3. 出力
############################################################
output "disk_name" {
  value = sakuracloud_disk.disk_from_tofu.name
  description = "作成したディスク名"
}

output "switch_name" {
  value = sakuracloud_switch.my_switch.name
  description = "作成したスイッチ名"
}
