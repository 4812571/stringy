FROM golang:1.18 as builder

COPY . /gommit
WORKDIR /gommit/mayhem

RUN go install github.com/dvyukov/go-fuzz/go-fuzz@latest github.com/dvyukov/go-fuzz/go-fuzz-build@latest
RUN go get github.com/dvyukov/go-fuzz/go-fuzz-dep
RUN go get github.com/AdaLogics/go-fuzz-headers
RUN apt update && apt install -y clang

RUN cd fuzz_stringy && go-fuzz-build -libfuzzer -o fuzz_stringy.a && \
    clang -fsanitize=fuzzer fuzz_stringy.a -o fuzz_stringy.libfuzzer

FROM debian:bookworm-slim

COPY --from=builder /gommit/mayhem/fuzz_stringy/fuzz_stringy.libfuzzer /