# homebrew-tensorfold

Homebrew tap for [TensorFold](https://github.com/ashhart/TensorFold), an OpenAI-compatible LLM server for Apple
silicon Macs. From 1.0.0 it installs the native binary, with no Python or MLX.

## Install

```sh
brew install ashhart/tensorfold/tensorfold
```

Or add the tap once and install by name:

```sh
brew tap ashhart/tensorfold
brew install tensorfold
```

You need an Apple silicon Mac on macOS 13 or newer. The formula installs the release archive's `tensorfold-native`
binary and links it as `tensorfold`.

The Python engine stays available at 0.6.6:

```sh
brew install ashhart/tensorfold/tensorfold@0.6
```

It is keg-only, so it doesn't replace the native `tensorfold`.

## Models

The install has no model weights in it. Download a model into the Hugging Face cache, then serve it:

```sh
tensorfold pull TensorFold/NVIDIA-Nemotron-3.5-Lightning-30B-A3B-MLX-4bit
tensorfold serve TensorFold/NVIDIA-Nemotron-3.5-Lightning-30B-A3B-MLX-4bit
```

## Upgrade

```sh
brew update
brew upgrade tensorfold
```

Homebrew installs upgrade through brew.

## Uninstall

```sh
brew uninstall tensorfold
brew untap ashhart/tensorfold
```

Uninstalling leaves downloaded models in the Hugging Face cache (`~/.cache/huggingface` unless `HF_HOME` points
elsewhere). Delete them there to get the disk space back.

## License

Apache-2.0, like TensorFold.
