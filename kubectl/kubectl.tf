// Install argocd using kubectl according to official docs: https://argoproj.github.io/argo-cd/getting_started/
resource "null_resource" "install-argocd" {
  provisioner "local-exec" {
    command = <<EOH
      kubectl \
        --kubeconfig ${var.kube_config_path} \
        create namespace argocd && \
      kubectl \
        --kubeconfig ${var.kube_config_path} \
        apply \
        -n argocd \
        -f ./kubectl/install.yaml && \
      kubectl \
        --kubeconfig ${var.kube_config_path} \
        patch svc argocd-server \
        -n argocd \
        -p '{"spec": {"type": "LoadBalancer"}}'
    EOH
  }
}

// There needs init argocd provider by setting environment before running argocd resources.
resource "null_resource" "init-argocd" {
  depends_on = [null_resource.install-argocd]
  provisioner "local-exec" {
    command = <<EOF
      sleep 20s && \
      echo export ARGOCD_SERVER=`kubectl --kubeconfig ${var.kube_config_path} get -n argocd svc | grep argocd-server | grep LoadBalancer | awk '{print $4}'` > ${var.argocd_provider_config} && \
      echo export ARGOCD_AUTH_USERNAME="admin" >> ${var.argocd_provider_config} && \
      echo export ARGOCD_AUTH_PASSWORD=`kubectl --kubeconfig ${var.kube_config_path} get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2` >> ${var.argocd_provider_config} && \
      echo export ARGOCD_INSECURE=true >> ${var.argocd_provider_config} && \
      source ${var.argocd_provider_config}
    EOF
  }
}

resource "null_resource" "apply-argocd" {
  depends_on = [null_resource.init-argocd]
  // The argocd resource requires the argocd config like server addr,auto password when terraform init.
  // Once the addr and password has been generated, the argocd resource can be run successfully.
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
      cp -rf argocd.tf.pre argocd.tf
      source ${var.argocd_provider_config}
    EOF
  }
}