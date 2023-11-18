build:
	@docker build . -t bootstrap-ansible:0.0.1

test: build
	@docker run -ti --rm bootstrap-ansible:0.0.1 bash --login -c "ansible --version"