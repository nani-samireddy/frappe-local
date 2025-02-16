import { useRef, useState } from "react";
// import { invoke } from "@tauri-apps/api/core";
import { setupBench } from "./actions/setup-bench";
import "./App.css";

function App() {
  const benchNameRef = useRef<HTMLInputElement>(null);
  const [message, setMessage] = useState<string | null>(null);
  const handleCreateBench = async () => {
    if (benchNameRef.current) {
      const benchName = benchNameRef.current.value;
      try {
        // const res = await invoke("init_bench", { name: benchName });
        // console.log(res);
        await setupBench(benchName, setMessage);
      } catch (error) {
        console.error(error);
      }
    }
  };
  return (
    <main className="bg-yellow-500 p-4">
     <h1>hehehhehe</h1>
     <input type="text" ref={benchNameRef} placeholder="Enter bench name" />
     <button onClick={handleCreateBench}>Create</button>
      {message && <>
        <h3>Progress</h3>
        {
          message.split("<br/>").map((msg, index) => (
            <p key={index}>{msg}</p>
          ))
        }
      </>}
    </main>
  );
}

export default App;
