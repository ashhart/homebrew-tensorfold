# homebrew-tensorfold

Homebrew tap for [TensorFold](https://github.com/ashhart/TensorFold), an OpenAI-compatible LLM server for Apple
silicon Macs.

## Install

```sh
brew install ashhart/tensorfold/tensorfold
```

Or add the tap once and install by name:

```sh
brew tap ashhart/tensorfold
brew install tensorfold
```

You need an Apple silicon Mac on macOS 14 or newer. The formula puts TensorFold and its Python packages, MLX
included, in a private environment that runs on Homebrew's Python 3.14.

## Models

The install has no model weights in it. TensorFold downloads a model to the Hugging Face cache the first time you
serve or pull it, for example:

```sh
tensorfold serve TensorFold/NVIDIA-Nemotron-3.5-Lightning-30B-A3B-MLX-4bit
```

## Upgrade

```sh
brew update
brew upgrade tensorfold
```

`tensorfold update` is for pip installs. Homebrew installs upgrade through brew.

## Uninstall

```sh
brew uninstall tensorfold
brew untap ashhart/tensorfold
```

Uninstalling leaves downloaded models in the Hugging Face cache (`~/.cache/huggingface` unless `HF_HOME` points
elsewhere). Delete them there to get the disk space back.

## License

Apache-2.0, like TensorFold.
