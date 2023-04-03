# Creates an alarm for upscaling the ASG when CPU utilization is >= 80%
resource "aws_cloudwatch_metric_alarm" "scale-up-cpu-alarm" {
  alarm_name          = "scale-up-cpu-alarm"
  alarm_description   = "CPU Alarm for ASG up scaling"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  dimensions = {
    "AutoScalingGroupName" = "${module.wp-asg.autoscaling_group_name}"
  }
  actions_enabled = true
  alarm_actions   = ["${module.wp-asg.autoscaling_policy_arns.scale-up}"]
  tags            = var.tags
}

# Creates an alarm for downscaling the ASG when CPU utilization is <= 30%
resource "aws_cloudwatch_metric_alarm" "scale-down-cpu-alarm" {
  alarm_name          = "scale-down-cpu-alarm"
  alarm_description   = "CPU Alarm for ASG down scaling"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    "AutoScalingGroupName" = "${module.wp-asg.autoscaling_group_name}"
  }
  actions_enabled = true
  alarm_actions   = ["${module.wp-asg.autoscaling_policy_arns.scale-down}"]
  tags            = var.tags
}
