project = "example-nodejs"

app "frontend" {
  build {
    use "docker" {}

	# Uncomment below to use a remote docker registry to push your built images.
    #
    # registry {
    #   use "docker" {
    #     image = "registry.example.com/image"
    #     tag   = "latest"
    #   }
    # }
  }

  deploy {
	// Lets just deploy this locally
    use "docker" {
      service_port = 8080
    }
  }
}