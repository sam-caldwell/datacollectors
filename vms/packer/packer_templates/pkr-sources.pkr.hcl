locals {
  parallels_tools_flavor = var.parallels_tools_flavor == null ? (
  var.os_arch == "x86_64" ? "lin" : "lin-arm"
  ) : var.parallels_tools_flavor
  parallels_tools_mode = var.parallels_tools_mode == null ? "upload" : var.parallels_tools_mode
  parallels_prlctl     = var.parallels_prlctl == null ? [
    ["set", "{{ .Name }}", "--3d-accelerate", "off"],
    ["set", "{{ .Name }}", "--videosize", "16"]
  ] : var.parallels_prlctl
  qemuargs = var.qemuargs == null ? [
    ["-m", "${local.memory}"],
    ["-display", "none"]
  ] : var.qemuargs
  vbox_gfx_controller = var.vbox_gfx_controller == null ? "vmsvga" : var.vbox_gfx_controller
  vbox_gfx_vram_size = var.vbox_gfx_controller == null ? 33 : var.vbox_gfx_vram_size
  vbox_guest_additions_mode = var.vbox_guest_additions_mode == null ? "upload" : var.vbox_guest_additions_mode
  vbox_source = var.vbox_source
  boot_wait = var.boot_wait == null? "5s" : var.boot_wait
  cd_files         = var.cd_files
  communicator     = var.communicator
  floppy_files     = var.floppy_files
  http_directory   = var.http_directory == null ? "${path.root}/http" : var.http_directory
  memory           = var.memory == null ? 2048 : var.memory
  output_directory = var.output_directory
  shutdown_command = var.shutdown_command
  vm_name          = var.vm_name
}

source "parallels-iso" "vm" {
  guest_os_type          = var.parallels_guest_os_type
  parallels_tools_flavor = local.parallels_tools_flavor
  parallels_tools_mode   = local.parallels_tools_mode
  prlctl                 = local.parallels_prlctl
  prlctl_version_file    = var.parallels_prlctl_version_file
  boot_command           = var.boot_command
  boot_wait              = local.boot_wait
  cpus                   = var.cpus
  communicator           = local.communicator
  disk_size              = var.disk_size
  floppy_files           = local.floppy_files
  http_directory         = local.http_directory
  iso_checksum           = var.iso_checksum
  iso_url                = var.iso_url
  memory                 = local.memory
  output_directory       = "${local.output_directory}/parallels"
  shutdown_command       = local.shutdown_command
  shutdown_timeout       = var.shutdown_timeout
  ssh_password           = var.ssh_password
  ssh_port               = var.ssh_port
  ssh_timeout            = var.ssh_timeout
  ssh_username           = var.ssh_username
  vm_name                = local.vm_name
}
source "qemu" "vm" {
  accelerator      = var.qemu_accelerator
  qemuargs         = local.qemuargs
  boot_command     = var.boot_command
  boot_wait        = local.boot_wait
  cd_files         = local.cd_files
  cpus             = var.cpus
  communicator     = local.communicator
  disk_size        = var.disk_size
  floppy_files     = local.floppy_files
  headless         = var.headless
  http_directory   = local.http_directory
  iso_checksum     = var.iso_checksum
  iso_url          = var.iso_url
  memory           = local.memory
  output_directory = "${local.output_directory}/qemu"
  shutdown_command = local.shutdown_command
  shutdown_timeout = var.shutdown_timeout
  ssh_password     = var.ssh_password
  ssh_port         = var.ssh_port
  ssh_timeout      = var.ssh_timeout
  ssh_username     = var.ssh_username
  vm_name          = local.vm_name
}
source "virtualbox-iso" "vm" {
  gfx_controller            = local.vbox_gfx_controller
  gfx_vram_size             = local.vbox_gfx_vram_size
  guest_additions_path      = var.vbox_guest_additions_path
  guest_additions_mode      = local.vbox_guest_additions_mode
  guest_additions_interface = var.vbox_guest_additions_interface
  guest_os_type             = var.vbox_guest_os_type
  hard_drive_interface      = var.vbox_hard_drive_interface
  iso_interface             = var.vbox_iso_interface
  vboxmanage                = var.vboxmanage
  virtualbox_version_file   = var.virtualbox_version_file
  boot_command              = var.boot_command
  boot_wait                 = local.boot_wait
  cpus                      = var.cpus
  communicator              = local.communicator
  disk_size                 = var.disk_size
  floppy_files              = local.floppy_files
  headless                  = var.headless
  http_directory            = local.http_directory
  iso_checksum              = var.iso_checksum
  iso_url                   = var.iso_url
  memory                    = local.memory
  output_directory          = "${local.output_directory}/virtualbox"
  shutdown_command          = local.shutdown_command
  shutdown_timeout          = var.shutdown_timeout
  ssh_password              = var.ssh_password
  ssh_port                  = var.ssh_port
  ssh_timeout               = var.ssh_timeout
  ssh_username              = var.ssh_username
  vm_name                   = local.vm_name
}
