cProfile, total time for functions including subfunctions

python -m cProfile -s cumtime -o %cd%/profiling/profile.txt %cd%/src/exercise_mlops/train.py

1. Show numbers of longest runtime
import pstats
p = pstats.Stats('profile.txt')
p.sort_stats('cumulative').print_stats(10)

To minimize runtime, data type conversion should be done from parent.

pytorch profiling

2. torch + tensorflow
profile, tensorboard_trace_handler
example in torch_profiler.py

train.py
with profile(...) as prof:
    for i in epochs:
        ...
        model(inputs)
        prof.step()
        ...
# with the addition of ProfilerActivity we can compile the code for log the profile
$python src/exercise_mlops/train.py

# show the profiler dashboard
$tensorboard --logdir=src/exercise_mlops/lo 
