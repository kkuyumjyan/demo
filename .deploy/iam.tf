data "aws_sqs_queue" "demo_api" {
  name = "demo-eventpublisher-${local.env}.fifo"
}

data "aws_iam_policy_document" "demo_api" {
  version = "2012-10-17"
  statement {
    sid = "1"
    effect = "Allow"
    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueUrl",
      "sqs:ListQueues",
      "sqs:ChangeMessageVisibility",
      "sqs:SendMessageBatch",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
      "sqs:ListQueueTags",
      "sqs:ListDeadLetterSourceQueues",
      "sqs:DeleteMessageBatch",
      "sqs:ChangeMessageVisibilityBatch",
      "sqs:SetQueueAttributes"
    ]
    resources = [data.aws_sqs_queue.demo_api.arn]
  }
}

resource "aws_iam_policy" "demo_api" {
  name = "demo-api-sqs-${local.env}"
  policy = data.aws_iam_policy_document.demo_api.json
}

resource "aws_iam_user" "demo_api" {
  name = "demo-api-${local.env}"
}

resource "aws_iam_access_key" "demo_api" {
  user = aws_iam_user.demo_api.name
}

resource "aws_iam_user_policy_attachment" "sqs" {
  policy_arn = aws_iam_policy.demo_api.arn
  user       = aws_iam_user.demo_api.name
}
