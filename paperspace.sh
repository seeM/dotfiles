rm -rf ~/.cache/huggingface
ln -s /storage/huggingface ~/.cache/huggingface

rm -rf ~/.ssh
ln -s /storage/cfg/.ssh ~/.ssh

rm -rf ~/.jupyter
ln -s /storage/cfg/dotfiles/jupyter/.jupyter ~/.jupyter

rm ~/.bashrc
ln -s /storage/cfg/dotfiles/bash/.bashrc ~/.bashrc

rm ~/.gitconfig
ln -s /storage/cfg/dotfiles/git/.gitconfig ~/.gitconfig
