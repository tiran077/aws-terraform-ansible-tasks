### The Ansible inventory file

resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl", {
    private-dns = aws_instance.demo.*.private_dns,
    private-ip  = aws_instance.demo.*.private_ip,
    private-id  = aws_instance.demo.*.id
  })
  filename = "inventory"
}
