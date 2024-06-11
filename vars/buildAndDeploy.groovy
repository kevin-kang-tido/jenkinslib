def call(Map config = [:]) {
    // Load Dockerfile content from the library
        def dockerfileContent = libraryResource('next.dockerfile')
        writeFile file: 'Dockerfile', text: dockerfileContent
    // Default values
    def image = config.get('image', 'my-default-image')
    def registry = config.get('registry', 'my-default-registry')
    def tag = config.get('tag', 'latest')
    def containerPort = config.get('containerPort', '8080')
    def hostPort = config.get('hostPort', '8080')
}
