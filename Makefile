DOCKER_IMAGES := $(docker images |grep 'starlette_context')

test:
	docker-compose -f docker-compose.yml run --rm tests sh scripts/test.sh

rebuild:
	docker-compose -f docker-compose.yml up --build


purge:
	sh scripts/clean.sh
	docker-compose rm -sfv
	clean_docker

clean_docker:
	@if [ -n "$(DOCKER_IMAGES)" ]; then echo "Removing docker"; else echo "Nothing found"; fi;

lint:
	pre-commit run --all-files

bash:
	docker-compose -f docker-compose.yml run --rm tests sh

doc:
	docker-compose -f docker-compose.yml run --rm tests sh -c "cd docs && make html"

push:
	sh scripts/clean.sh
	increment-patch
	docker-compose -f docker-compose.yml run --rm tests sh -c "python setup.py sdist"
	docker-compose -f docker-compose.yml run --rm tests sh -c "twine upload dist/*"

increment-patch:
	docker-compose -f docker-compose.yml run --rm tests sh -c "bump2version part patch"