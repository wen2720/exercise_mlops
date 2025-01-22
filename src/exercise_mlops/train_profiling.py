import matplotlib.pyplot as plt
import torch
import typer
import wandb
from data import corrupt_mnist
from model import MyAwesomeModel
from torch.profiler import profile, tensorboard_trace_handler,  ProfilerActivity


DEVICE = torch.device("cuda" if torch.cuda.is_available() else "mps" if torch.backends.mps.is_available() else "cpu")
print(f"Training on {DEVICE}")

def train(lr: float = 1e-3, batch_size: int = 32, epochs: int = 5) -> None:
    """Train a model on MNIST."""
    print("Training day and night")
    print(f"{lr=}, {batch_size=}, {epochs=}")

    model = MyAwesomeModel().to(DEVICE)
    train_set, _ = corrupt_mnist()

    train_dataloader = torch.utils.data.DataLoader(train_set, batch_size=batch_size)

    loss_fn = torch.nn.CrossEntropyLoss()
    optimizer = torch.optim.Adam(model.parameters(), lr=lr)

    statistics = {"train_loss": [], "train_accuracy": []}
    with profile(
        activities=[ProfilerActivity.CPU, ProfilerActivity.CUDA],
        on_trace_ready=tensorboard_trace_handler("src/exercise_mlops/profiling/resnet18"),  # Directory for saving TensorBoard logs
        schedule=torch.profiler.schedule(wait=1, warmup=1, active=3, repeat=2),
        with_stack=True,  # Collect stack trace information
        record_shapes=True,  # Record tensor shapes
    ) as prof:
        
        for epoch in range(epochs):
            model.train()
            for i, (img, target) in enumerate(train_dataloader):
                img, target = img.to(DEVICE), target.to(DEVICE)
                optimizer.zero_grad()
                y_pred = model(img)
                loss = loss_fn(y_pred, target)
                loss.backward()
                optimizer.step()
                statistics["train_loss"].append(loss.item())

                accuracy = (y_pred.argmax(dim=1) == target).float().mean().item()
                statistics["train_accuracy"].append(accuracy)

                if i % 100 == 0:
                    print(f"Epoch {epoch}, iter {i}, loss: {loss.item()}")
                prof.step()

    print("Training complete")
    torch.save(model.state_dict(), "models/corruptmnist/model.pth")
    fig, axs = plt.subplots(1, 2, figsize=(15, 5))
    axs[0].plot(statistics["train_loss"])
    axs[0].set_title("Train loss")
    axs[1].plot(statistics["train_accuracy"])
    axs[1].set_title("Train accuracy")
    fig.savefig("reports/figures/corruptmnist/training_statistics.png")


if __name__ == "__main__":
    typer.run(train)
