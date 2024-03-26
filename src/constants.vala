public struct Genre {
    string stream;
    string ws;
}

const Genre JPOP_GENRE = {
    "https://listen.moe/stream",
    "wss://listen.moe/gateway_v2",
};

const Genre KPOP_GENRE = {
    "https://listen.moe/kpop/stream",
    "wss://listen.moe/kpop/gateway_v2",
};
