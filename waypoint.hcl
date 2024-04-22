project = "example-nodejs"

app "frontend" {
  build {
    use "docker" {
      context = "./src/frontend/"
	    dockerfile = "./Dockerfile"
    }
  }

  deploy {
	// Lets just deploy this locally
    use "docker" {
      service_port = 8080
    }
  }
}

app "backend" {
  build {
    use "docker" {
      context = "./src/backend/"
	    dockerfile = "./Dockerfile"
    }
  }

  deploy {
	// Lets just deploy this locally
    use "docker" {
      service_port = 4040
    }
  }
}

