variable "common_tags" {
  description = "This is to help you add tags to your cloud objects"
  type        = map(any)
}

variable "project" {
}

variable "key" {
}

variable "repository" {
  type = object({
    id          = string
    description = string
    format      = string
    location    = string
  })
  description = "(optional) describe your variable"
}
