# in an effort to have our terraform modules reusable/repeatable, here we set our variables

variable "ami_name" {
  type    = string
  default = "group_excercise"
}
variable "ami_id" {
  type    = string
  default = "ami-026b57f3c383c2eec"
}
variable "ami_key_pair_name" {
  type    = string
  default = "anotherone"
}
