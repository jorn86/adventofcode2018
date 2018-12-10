package net.worcade;

import com.google.common.base.Joiner;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import com.google.common.collect.Ordering;
import com.google.common.collect.Sets;
import com.google.common.graph.Graph;
import com.google.common.graph.GraphBuilder;
import com.google.common.graph.MutableGraph;

import java.util.List;
import java.util.Set;

// java because dart doesn't seem to have a capable graphing library
public class Day7 {
    private static final String input =
            "Step C must be finished before step A can begin.\n" +
            "Step C must be finished before step F can begin.\n" +
            "Step A must be finished before step B can begin.\n" +
            "Step A must be finished before step D can begin.\n" +
            "Step B must be finished before step E can begin.\n" +
            "Step D must be finished before step E can begin.\n" +
            "Step F must be finished before step E can begin.\n";
    private static final String input2 =
            "Step A must be finished before step R can begin.\n" +
            "Step J must be finished before step B can begin.\n" +
            "Step D must be finished before step B can begin.\n" +
            "Step X must be finished before step Z can begin.\n" +
            "Step H must be finished before step M can begin.\n" +
            "Step B must be finished before step F can begin.\n" +
            "Step Q must be finished before step I can begin.\n" +
            "Step U must be finished before step O can begin.\n" +
            "Step T must be finished before step W can begin.\n" +
            "Step V must be finished before step S can begin.\n" +
            "Step N must be finished before step P can begin.\n" +
            "Step P must be finished before step O can begin.\n" +
            "Step E must be finished before step C can begin.\n" +
            "Step F must be finished before step O can begin.\n" +
            "Step G must be finished before step I can begin.\n" +
            "Step Y must be finished before step Z can begin.\n" +
            "Step M must be finished before step K can begin.\n" +
            "Step C must be finished before step W can begin.\n" +
            "Step L must be finished before step W can begin.\n" +
            "Step W must be finished before step S can begin.\n" +
            "Step Z must be finished before step O can begin.\n" +
            "Step K must be finished before step S can begin.\n" +
            "Step S must be finished before step R can begin.\n" +
            "Step R must be finished before step I can begin.\n" +
            "Step O must be finished before step I can begin.\n" +
            "Step A must be finished before step Q can begin.\n" +
            "Step Z must be finished before step R can begin.\n" +
            "Step T must be finished before step R can begin.\n" +
            "Step M must be finished before step O can begin.\n" +
            "Step Q must be finished before step Z can begin.\n" +
            "Step V must be finished before step C can begin.\n" +
            "Step Y must be finished before step W can begin.\n" +
            "Step N must be finished before step F can begin.\n" +
            "Step J must be finished before step D can begin.\n" +
            "Step D must be finished before step N can begin.\n" +
            "Step B must be finished before step M can begin.\n" +
            "Step P must be finished before step I can begin.\n" +
            "Step W must be finished before step Z can begin.\n" +
            "Step Q must be finished before step V can begin.\n" +
            "Step V must be finished before step K can begin.\n" +
            "Step B must be finished before step Z can begin.\n" +
            "Step M must be finished before step I can begin.\n" +
            "Step G must be finished before step C can begin.\n" +
            "Step K must be finished before step O can begin.\n" +
            "Step E must be finished before step O can begin.\n" +
            "Step C must be finished before step I can begin.\n" +
            "Step X must be finished before step G can begin.\n" +
            "Step B must be finished before step T can begin.\n" +
            "Step B must be finished before step I can begin.\n" +
            "Step E must be finished before step F can begin.\n" +
            "Step N must be finished before step K can begin.\n" +
            "Step D must be finished before step W can begin.\n" +
            "Step R must be finished before step O can begin.\n" +
            "Step V must be finished before step I can begin.\n" +
            "Step T must be finished before step O can begin.\n" +
            "Step B must be finished before step Q can begin.\n" +
            "Step T must be finished before step L can begin.\n" +
            "Step M must be finished before step C can begin.\n" +
            "Step A must be finished before step M can begin.\n" +
            "Step F must be finished before step L can begin.\n" +
            "Step X must be finished before step T can begin.\n" +
            "Step G must be finished before step K can begin.\n" +
            "Step C must be finished before step L can begin.\n" +
            "Step D must be finished before step Z can begin.\n" +
            "Step H must be finished before step L can begin.\n" +
            "Step P must be finished before step Z can begin.\n" +
            "Step A must be finished before step V can begin.\n" +
            "Step G must be finished before step R can begin.\n" +
            "Step E must be finished before step G can begin.\n" +
            "Step D must be finished before step P can begin.\n" +
            "Step X must be finished before step L can begin.\n" +
            "Step U must be finished before step C can begin.\n" +
            "Step Z must be finished before step K can begin.\n" +
            "Step E must be finished before step W can begin.\n" +
            "Step B must be finished before step Y can begin.\n" +
            "Step J must be finished before step I can begin.\n" +
            "Step U must be finished before step P can begin.\n" +
            "Step Y must be finished before step L can begin.\n" +
            "Step N must be finished before step L can begin.\n" +
            "Step L must be finished before step S can begin.\n" +
            "Step H must be finished before step P can begin.\n" +
            "Step P must be finished before step S can begin.\n" +
            "Step J must be finished before step S can begin.\n" +
            "Step J must be finished before step U can begin.\n" +
            "Step H must be finished before step T can begin.\n" +
            "Step L must be finished before step I can begin.\n" +
            "Step N must be finished before step Z can begin.\n" +
            "Step A must be finished before step G can begin.\n" +
            "Step H must be finished before step S can begin.\n" +
            "Step S must be finished before step I can begin.\n" +
            "Step H must be finished before step E can begin.\n" +
            "Step W must be finished before step R can begin.\n" +
            "Step B must be finished before step G can begin.\n" +
            "Step U must be finished before step Y can begin.\n" +
            "Step J must be finished before step G can begin.\n" +
            "Step M must be finished before step L can begin.\n" +
            "Step G must be finished before step Z can begin.\n" +
            "Step N must be finished before step W can begin.\n" +
            "Step D must be finished before step E can begin.\n" +
            "Step A must be finished before step W can begin.\n" +
            "Step G must be finished before step Y can begin.";

    private static final int workerCount = 5;
    private static final int addedTime = 60;

    public static void main(String[] args) {
        MutableGraph<String> forwardGraph = GraphBuilder.directed().allowsSelfLoops(false).build();
        for (String line : input2.split("\n")) {
            String source = line.substring(5, 6);
            String target = line.substring(36, 37);
            forwardGraph.putEdge(source, target);
        }
        System.out.println(forwardGraph.edges());

        Set<String> queued = findRoots(forwardGraph);
        Set<String> result = Sets.newLinkedHashSet();
        while (!queued.isEmpty()) {
            String next = Iterables.getFirst(queued, null);
            queued.remove(next);
            result.add(next);

            Set<String> successors = forwardGraph.successors(next);
            for (String successor : successors) {
                if (!result.contains(successor) && result.containsAll(forwardGraph.predecessors(successor))) {
                    queued.add(successor);
                }
            }
        }
        System.out.println(Joiner.on("").join(result)); // step 1

        queued = findRoots(forwardGraph);
        Workers workers = new Workers();
        Set<String> done = Sets.newLinkedHashSet();
        while (true) {
            while (!queued.isEmpty() && !workers.isFull()) {
                String next = Iterables.getFirst(queued, null);
                workers.startOn(next); // when this throws, the answer of step 2 is the end time of the last logged start
                queued.remove(next);
                System.out.println();
            }

            String nowDone = workers.nextDone();
            done.add(nowDone);
            System.out.println("done: " + done);
            Set<String> successors = forwardGraph.successors(nowDone);
            for (String successor : successors) {
                if (!done.contains(successor) && done.containsAll(forwardGraph.predecessors(successor))) {
                    queued.add(successor);
                }
            }
        }
    }

    private static Set<String> findRoots(Graph<String> graph) {
        Set<String> roots = Sets.newTreeSet();
        for (String node : graph.nodes()) {
            if (graph.predecessors(node).isEmpty()) {
                roots.add(node);
            }
        }
        return roots;
    }

    private static class Workers {
        private final List<Task> tasks = Lists.newArrayList();
        private int currentTime = 0;

        String nextDone() {
            Task done = tasks.stream()
                    .filter(t -> !t.done)
                    .sorted(Ordering.natural().onResultOf(Task::getTask))
                    .min(Ordering.natural().onResultOf(Task::getEndTime))
                    .orElseThrow(IllegalStateException::new);
            currentTime = done.getEndTime();
            done.done();
            return done.getTask();
        }

        void startOn(String task) {
            int time = addedTime + (task.charAt(0) - 64);
            System.out.println(task + " from " + currentTime + " to " + (currentTime+time) + " on " + nextAvailableWorker());
            tasks.add(new Task(nextAvailableWorker(), task, currentTime, currentTime + time));
        }

        private int nextAvailableWorker() {
            w: for (int i = 0; i < workerCount; i++) {
                for (Task t : tasks) {
                    if (t.getWorkerIndex() == i) {
                        continue w;
                    }
                }
                return i;
            }
            Task task = tasks.stream().min(Ordering.natural().onResultOf(Task::getEndTime)).orElseThrow(IllegalStateException::new);
            if (task.getEndTime() > currentTime) currentTime = task.getEndTime();
            return task.getWorkerIndex();
        }

        boolean isFull() {
            return tasks.stream().filter(task -> !task.done).count() == workerCount;
        }
    }

    private static class Task {
        private final int workerIndex;
        private final String task;
        private final int startTime;
        private final int endTime;
        private boolean done = false;

        Task(int workerIndex, String task, int startTime, int endTime) {
            this.workerIndex = workerIndex;
            this.task = task;
            this.startTime = startTime;
            this.endTime = endTime;
        }

        int getWorkerIndex() {
            return this.workerIndex;
        }

        String getTask() {
            return this.task;
        }

        int getStartTime() {
            return this.startTime;
        }

        int getEndTime() {
            return this.endTime;
        }

        void done() {
            this.done = true;
        }
    }
}
