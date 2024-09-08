variable "RELEASE" {
    default = "0.8.7"
}

target "default" {
  dockerfile = "Dockerfile"
  tags = ["dyamagishi/kohya-ss-sd-scripts:${RELEASE}-cu118"]
  contexts = {
    scripts = "../../container-template"
    proxy = "../../container-template/proxy"
  }
  args = {
    SD_SCRIPTS_VERSION = "v0.8.7"
    TORCH_VERSION = "2.1.2+cu118"
    TORCHVISION_VERSION = "0.16.2+cu118"
    XFORMERS_VERSION = "0.0.23.post1+cu118"
  }
}
