import { useRef, useState } from "react";
// import { invoke } from "@tauri-apps/api/core";
import { setupBench } from "./actions/setup-bench";
import "./global.css";
import { CreateBenchDialog } from "./components/actions/create-bench-dialog";
import Layout from "./layout";


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
    <Layout>
      <main className="p-4">
     <h1>LocalFrap</h1>
     <CreateBenchDialog />
     <input type="text" ref={benchNameRef} placeholder="Enter bench name" />
     <button onClick={handleCreateBench}>Create</button>
      {message && <>
        <div className="flex flex-col gap-2">
        {
          message.split("<br/>").map((msg, index) => (
            <p key={index}>{msg}</p>
          ))
        }
        </div>
      </>}
    </main>
    </Layout>
  );
}

export default App;
