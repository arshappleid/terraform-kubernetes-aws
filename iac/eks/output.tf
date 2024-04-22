output "mount_targets" {
  description = "Map of Mount Targets on the EFS drive"
  value       = module.efs.mount_targets
}
