packer {
  required_version = ">= 1.7.0"
  required_plugins {
    hyperv = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/hyperv"
    }
    inspec = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/inspec"
    }
    parallels = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/parallels"
    }
    qemu = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/qemu"
    }
    vagrant = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/vagrant"
    }
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

locals {
  scripts = [
    "${path.root}/scripts/${var.os_name}/update_${var.os_name}.sh",
    "${path.root}/scripts/_common/motd.sh",
    "${path.root}/scripts/_common/sshd.sh",
    "${path.root}/scripts/${var.os_name}/networking_${var.os_name}.sh",
    "${path.root}/scripts/${var.os_name}/sudoers_${var.os_name}.sh",
    "${path.root}/scripts/_common/vagrant.sh",
    "${path.root}/scripts/${var.os_name}/systemd_${var.os_name}.sh",
    "${path.root}/scripts/_common/virtualbox.sh",
    "${path.root}/scripts/_common/vmware_debian_ubuntu.sh",
    "${path.root}/scripts/_common/parallels.sh",
    "${path.root}/scripts/${var.os_name}/hyperv_${var.os_name}.sh",
    "${path.root}/scripts/${var.os_name}/cleanup_${var.os_name}.sh",
    "${path.root}/scripts/_common/minimize.sh"
  ]
  source_names = [for source in var.sources_enabled : trimprefix(source, "source.")]
}

# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = var.sources_enabled

  # Linux Shell scripts
  provisioner "shell" {
    environment_vars = [
      "HOME_DIR=/home/vagrant",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "no_proxy=${var.no_proxy}"
    ]
    execute_command   = "echo 'vagrant' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    expect_disconnect = true
    scripts           = local.scripts
    except            = local.source_names
  }
  post-processor "vagrant" {
    compression_level    = 9
    keep_input_artifact  = false
    output               = "${local.output_directory}/${var.os_name}-${var.os_version}-${var.os_arch}.{{ .Provider }}.box"
    vagrantfile_template = null
  }
}
