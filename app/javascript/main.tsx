import * as React from 'react';
import { createRoot } from 'react-dom/client';
import ReportWebVitals from './ReportWebVitals';

let container = null;

document.addEventListener('DOMContentLoaded', function(event) {
  if (!container) {
    container = document.getElementById('root1') as HTMLElement;
    const root = createRoot(container)
    root.render(
      <React.StrictMode>
        <h1>ZOO</h1>
      </React.StrictMode>
    );
  }
});

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
ReportWebVitals.report();

