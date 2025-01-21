import torch
import torchvision.models as models
from torch.profiler import profile, tensorboard_trace_handler,  ProfilerActivity

model = models.resnet18()
inputs = torch.randn(5, 3, 224, 224)

# 1. #run model forward function record performance
with profile(activities=[ProfilerActivity.CPU], record_shapes=True) as prof:
    model(inputs)

# print(prof.key_averages().table(sort_by="cpu_time_total", row_limit=10))

# 2.
# with profile(activities=[ProfilerActivity.CPU, ProfilerActivity.CUDA], record_shapes=True) as prof:
#     model(inputs)

# print(prof.key_averages().table(sort_by="cuda_time_total", row_limit=10))

# # 3. record from start to stop
# prof = profile(activities=[ProfilerActivity.CPU], record_shapes=True)
# prof.start()
# model(inputs)
# prof.stop()
# # output memory usage, can be observed cby hrome://tracing, sort by self_cpu_memory_usage
# prof.export_chrome_trace("trace.json")
# print(prof.key_averages().table(sort_by="cpu_time_total", row_limit=10))

# # 4. for train.py
# with profile(
#         activities=[ProfilerActivity.CPU, ProfilerActivity.CUDA],
#         on_trace_ready=tensorboard_trace_handler("src/exercise_mlops/log/resnet18"),  # Directory for saving TensorBoard logs
#         schedule=torch.profiler.schedule(wait=1, warmup=1, active=3, repeat=2),
#         with_stack=True,  # Collect stack trace information
#         record_shapes=True,  # Record tensor shapes
#     ) as prof:
