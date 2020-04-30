# GitHub Personal Access Token Required (set as env var GITHUB_TOKEN)
# https://github.com/settings/tokens
# Scopes: delete_repo, repo

PROJECT_NAME='disaster_tweets'

echo "Deleting GitHub Repo if it exists="$GITHUB_USERNAME/$PROJECT_NAME
curl -X DELETE -H 'Authorization: token '$GITHUB_TOKEN \
https://api.github.com/repos/$GITHUB_USERNAME/$PROJECT_NAME

echo "Generating project=$PROJECT_NAME"
rm -Rf $PROJECT_NAME > /dev/null
cookiecutter --no-input ../cookiecutter-data-science/ PROJECT_NAME=$PROJECT_NAME
cd $PROJECT_NAME

echo "Activating venv"
source venv/bin/activate

echo "Making initial git commit"
git add . > /dev/null
git commit -m "Inital project structure" > /dev/null

echo "Creating src/util directory"
mkdir src/util

echo "Copying existing notebooks and scripts"
cp ../explore.ipynb notebooks/.
cp ../prepare_train.ipynb notebooks/.
cp ../notebook_imports.py src/util/.
cp ../dataset.py src/util/.
cp ../download*.sh src/data/
cp ../train.py src/models/

echo "Appending project-specific requirements"
cat ../requirements.txt >> requirements.txt
echo "Installing project-specific requirements"
pip install -r requirements.txt > /dev/null

echo "Making dataset scripts executable"
chmod 755 src/data/*.sh

echo "Commiting progress"
git add . > /dev/null
git commit -m "Added project requirements and project files" > /dev/null

echo "Setup dvc s3 remote"
inv setup.s3.dvc

echo "Downloading competition dataset and saving as a DVC stage"
# https://dvc.org/doc/command-reference/run
dvc run -d src/data/download_dataset.sh \
        -o data/raw/train.csv \
        -o data/raw/test.csv \
        -o data/raw/sample_submission.csv \
        -f download_dataset.dvc \
        src/data/download_dataset.sh

echo "Downloading glove dataset and saving as a DVC stage"
dvc run -d src/data/download_glove.sh \
        -o data/raw/glove.6B.100d.txt \
        -f download_glove.dvc \
        src/data/download_glove.sh

echo "Invoking exploratory notebook"
inv notebooks.run notebooks/explore.ipynb

echo "Commiting progress"
git add . > /dev/null
git commit -m "Added dvc download stages" > /dev/null

echo "Create GitHub Repo=git@github.com:$GITHUB_USERNAME/$PROJECT_NAME.git"
payload='{"name":"'$PROJECT_NAME'"}'
curl -u $GITHUB_USERNAME:$GITHUB_TOKEN https://api.github.com/user/repos -d $payload
echo "Add remote origin="git@github.com:$GITHUB_USERNAME/$PROJECT_NAME.git
git remote add origin git@github.com:$GITHUB_USERNAME/$PROJECT_NAME.git
git push -u origin master

echo "Create and run the training stage"
# https://dvc.org/doc/command-reference/run
dvc run -d data/raw/train.csv \
        -d data/raw/glove.6B.100d.txt \
        -d src/models/train.py \
        -o models/model.h \
        -o models/tokenizer.pickle \
        -f train.dvc \
        python src/models/train.py

echo "Commiting progress"
git add . > /dev/null
git commit -m "Added dvc train stage" > /dev/null

# TODO
# Invoke the model with inv model.predict
# Try the web service?
# Show how to use as a Python package?
