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
############################################################
data "sakuracloud_archive" "rockylinux" {
  os_type = "rockylinux"
}



resource "sakuracloud_switch" "my_switch" {
  name = "my-open-tofu-switch"
  description = "Created via OpenTofu"
  tags        = ["202507", "tofu"]
}


############################################################
# 3. 出力
############################################################
