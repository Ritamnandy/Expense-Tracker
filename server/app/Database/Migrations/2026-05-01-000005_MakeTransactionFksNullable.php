<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class MakeTransactionFksNullable extends Migration
{
    public function up(): void
    {
        $this->forge->modifyColumn('transactions', [
            'account_id' => [
                'type'       => 'VARCHAR',
                'constraint' => 36,
                'null'       => true,
            ],
        ]);

        $this->forge->modifyColumn('transactions', [
            'category_id' => [
                'type'       => 'VARCHAR',
                'constraint' => 36,
                'null'       => true,
            ],
        ]);
    }

    public function down(): void
    {
        $this->forge->modifyColumn('transactions', [
            'account_id' => [
                'type'       => 'VARCHAR',
                'constraint' => 36,
                'null'       => false,
            ],
        ]);

        $this->forge->modifyColumn('transactions', [
            'category_id' => [
                'type'       => 'VARCHAR',
                'constraint' => 36,
                'null'       => false,
            ],
        ]);
    }
}
